require 'rubygems'
require 'activesupport'
require 'activeresource'

# The official Ruby library for interacting with the RESTful API of mite,
# a sleek time tracking webapp.
#  
# The first thing you need to set is the account name.  This is the same
# as the web address (subdomain) for your account.
#   
#   # if you access mite under demo.mite.yo.lk
#   Mite.account = 'demo'
# 
# Then, you should set the authentication. You can either use your login
# credentials (email and password) with HTTP Basic Authentication 
# or your mite api key. In both cases you must enable the mite.api in
# your user settings.
# 
#   # with basic authentication
#   Mite.authenticate('rick@techno-weenie.net', 'spacemonkey')
# 
#   # or, use your api key
#   Mite.key = 'cdfeasdaabcdefgssaeabcdefg'
# 
# You should read the complete mite.api documentation at 
# http://mite.yo.lk/api
#
module Mite
  class Error < StandardError; end
  class << self
    attr_accessor :email, :password, :host_format, :domain_format, :protocol, :port
    attr_reader :account, :key

    # Sets the account name, and updates all the resources with the new domain.
    def account=(name)
      resources.each do |klass|
        klass.site = klass.site_format % (host_format % [protocol, domain_format % name, ":#{port}"])
      end
      @account = name
    end

    # Sets up basic authentication credentials for all the resources.
    def authenticate(email, password)
      @email    = email
      @password = password
    end

    # Sets the API key for all the resources.
    def key=(value)
      resources.each do |klass|
        klass.headers['X-MiteApiKey'] = value
      end
      @key = value
    end

    def resources
      @resources ||= []
    end
  end
  
  self.host_format   = '%s://%s%s'
  self.domain_format = '%s.test.yo.lk'
  self.protocol      = 'http'
  self.port          = ''

  class Base < ActiveResource::Base
    class << self
      
      def inherited(base)
        Mite.resources << base
        class << base
          attr_accessor :site_format
        end
        base.site_format = '%s'
        super
      end
      
      # Common shortcuts known from ActiveRecord
      def all(options={})
        find_every(options)
      end

      def first(options={})
        find_every(options).first
      end

      def last(options={})
        find_every(options).last
      end
      
      
      # Undo destroy action on the resource with the ID in the +id+ parameter.
      def undo_destroy(id)
        returning(self.new(:id => id)) { |res| res.undo_destroy }
      end
    end
    
    # Undo destroy action.
    def undo_destroy
      path = element_path(prefix_options).sub(/\.([\w]+)/, '/undo_delete.\1')
      
      returning connection.post(path, "", self.class.headers) do |response|
        load_attributes_from_response(response)
      end
    end
  
  end
  
  class TimeEntry < Base
    
    def service
      @service ||= Service.find(service_id) unless service_id.blank?
    end
    
    def service=(service)
      self.service_id = service ? service.id : nil
      @service = service
    end
    
    def project
      @project ||= Project.find(project_id) unless project_id.blank?
    end
    
    def project=(project)
      self.project_id = project ? project.id : nil
      @project = project
    end
    
    def customer
      @customer ||= begin
        p = project
        p.customer unless p.blank?
      end
    end
    
    class << self
      def find_every(options={})
        return super(options) if !options[:params] || !options[:params][:group_by]
        TimeEntryGroup.all(options)
      end
    end
  end
  
  class TimeEntryGroup < Base
    self.collection_name = "time_entries"
    
    attr_accessor :time_entries_params
    
    class << self
      def find_every(options={})
        return TimeEntry.all(options) if !options[:params] || !options[:params][:group_by]
        
        returning super(options) do |records|
          records.each do |record| 
            if record.attributes["time_entries_params"]
              record.time_entries_params = record.attributes.delete("time_entries_params").attributes.stringify_keys
            end
          end
        end
      end
    end
    
    def time_entries(options={})
      return [] unless time_entries_params.is_a?(Hash)
      
      empty_result = false
      
      options[:params] ||= {}
      options[:params].stringify_keys!
      options[:params].merge!(time_entries_params) do |key, v1, v2|
        empty_result = (v1 != v2)
        v2
      end
      
      return [] if empty_result
      
      TimeEntry.all(options)
    end
  end
  
  # Find projects
  #
  #   Mite::Project.all          # find all projects for the current account.
  #   Mite::Project.find(1209)   # find individual project by ID
  #
  # Creating a Project
  #
  #   project = Mite::Project.new(:name => 'Roll it out')
  #   project.save
  #   # => true
  #   
  #   # or:
  #   project = Mite::Project.create(:name => 'Roll it back') 
  #
  # Updating a Project
  #
  #   project = Mite::Project.find(1209)
  #   project.name = "mite.api"
  #   project.customer = Mite::Customer.find(384)
  #   project.save
  #
  # Finding customer of project
  # 
  #   project = Mite::Project.find(1209)
  #   project.customer
  #
  # Deleting a project
  # 
  #   project = Mite::Project.find(1209)
  #   project.destroy
  #
  # Restore a destroyed project
  # (will only work for aprox. 12 hours)
  # 
  #    project = Mite::Project.undo_destroy(1209)
  #
  class Project < Base
    def time_entries(options = {})
      # [TODO] Support this query over rest
      TimeEntry.find(:all, :params => options.update(:project_id => id))
    end
  
    def customer
      @customer ||= Customer.find(customer_id) unless customer_id.blank?
    end
    
    def customer=(customer)
      self.customer_id = customer ? customer.id : nil
      @customer = customer
    end
  end
  
  class Customer < Base
    def time_entries(options = {})
      # [TODO] Support this query over rest 
      TimeEntry.find(:all, :params => options.update(:customer_id => id))
    end
  
    def projects(options = {})
      Project.find(:all, :params => options.update(:customer_id => id))
    end
  end
  
  class Service < Base
    def time_entries(options = {})
      # [TODO] Support this query over rest
      TimeEntry.find(:all, :params => options.update(:service_id => id))
    end
  end

  class User < Base
    def save
      raise Error, "Cannot modify users from the API"
    end
    
    def create
      raise Error, "Cannot create users from the API"
    end
    
    def destroy
      raise Error, "Cannot destroy users from the API"
    end
  end
end

module ActiveResource
  class Connection
    private
      def authorization_header
        (Mite.email || Mite.password ? { 'Authorization' => 'Basic ' + ["#{Mite.email}:#{Mite.password}"].pack('m').delete("\r\n") } : {})
      end
  end
end
