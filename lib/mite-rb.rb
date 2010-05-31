require 'active_support'
require 'active_resource'
require 'yaml'

# The official ruby library for interacting with the RESTful API of mite,
# a sleek time tracking webapp.

module Mite
  
  class << self
    attr_accessor :email, :password, :host_format, :domain_format, :protocol, :port, :user_agent
    attr_reader :account, :key

    # Sets the account name, and updates all resources with the new domain.
    def account=(name)
      resources.each do |klass|
        klass.site = klass.site_format % (host_format % [protocol, domain_format % name, ":#{port}"])
      end
      @account = name
    end

    # Sets up basic authentication credentials for all resources.
    def authenticate(user, password)
      resources.each do |klass|
        klass.user = user
        klass.password = password
      end
      @user     = user
      @password = password
      true
    end

    # Sets the mite.api key for all resources.
    def key=(value)
      resources.each do |klass|
        klass.headers['X-MiteApiKey'] = value
      end
      @key = value
    end
    
    # Sets the mite.user_agent for all resources.
    def user_agent=(user_agent)
      resources.each do |klass|
        klass.headers['User-Agent'] = user_agent
      end
      @user_agent = user_agent
    end

    def resources
      @resources ||= []
    end
  
    # Validates connection
    # returns true when valid false when not
    def validate
      validate! rescue false
    end
    
    # Same as validate_connection 
    # but raises http-error when connection is invalid
    def validate!
      !!Mite::Account.find
    end
  
    def version
      @version ||= begin
        config = YAML.load(File.read(File.join(File.dirname(__FILE__), "..", "VERSION.yml")))
        "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
      rescue
        "0.0.0"
      end
    end
  end
  
  self.host_format   = '%s://%s%s'
  self.domain_format = '%s.mite.yo.lk'
  self.protocol      = 'http'
  self.port          = ''
  self.user_agent    = "mite-rb/#{Mite.version}"
  
  class MethodNotAvaible < StandardError; end
  
  module ResourceWithoutWriteAccess
    def save
      raise MethodNotAvaible, "Cannot save #{self.class.name} over mite.api"
    end

    def create
      raise MethodNotAvaible, "Cannot save #{self.class.name} over mite.api"
    end

    def destroy
      raise MethodNotAvaible, "Cannot save #{self.class.name} over mite.api"
    end
  end
  
  module ResourceWithActiveArchived
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def archived(options={})
        find(:all, options.update(:from => :archived))
      end
      
      def active(options={})
        find(:all, options)
      end
    end
  end
  
  class Base < ActiveResource::Base
    class << self
      
      def inherited(base)
        unless base == Mite::SingletonBase
          Mite.resources << base
          class << base
            attr_accessor :site_format
          end
          base.headers['User-Agent'] = Mite.user_agent
          base.site_format = '%s'
          base.timeout = 20
        end
        super
      end
      
      # Common shortcuts known from ActiveRecord
      def all(options={})
        find(:all, options)
      end

      def first(options={})
        find_every(options).first
      end

      def last(options={})
        find_every(options).last
      end
    end
  
    private
    
    def query_string2(options)
      options.is_a?(String) ? "?#{options}" : super
    end
  end
  
  class SingletonBase < Base
    include ResourceWithoutWriteAccess
    
    class << self
      def collection_name
        element_name
      end

      def element_path(id, prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        "#{prefix(prefix_options)}#{collection_name}.#{format.extension}#{query_string(query_options)}"
      end

      def collection_path(prefix_options = {}, query_options = nil) 
        prefix_options, query_options = split_options(prefix_options) if query_options.nil? 
        "#{prefix(prefix_options)}#{collection_name}.#{format.extension}#{query_string(query_options)}" 
      end
    end
    
    def find
      super(1)
    end
    
    alias_method :first, :find
    alias_method :last, :find

    # Prevent collection methods
    def all
      raise MethodNotAvaible, "Method not supported on #{self.class.name}"
    end
  end
  
end

$:.unshift(File.dirname(__FILE__))
Dir[File.join(File.dirname(__FILE__), "mite/*.rb")].each { |f| require f }
