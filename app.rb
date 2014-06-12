require 'grape'
require 'singleton'
require 'forwardable'
require 'pp'

# If you set this true, it will put out some debugging info to STDOUT
# (usually the termninal that you started rackup with)
$debug = false

module MigrationCount

  # This is the resource we're managing. Not perssistant!
  class Migrations
    include Singleton
    
    attr_accessor :quantity
    
    def initialize
      @quantity = 0
    end

    # This bit of magic makes it so you don't have to say
    # Migrations.instance.quantity
    # I.E. Normally to access  methods that are using the Singleton
    # Gem, you have to use the itermediate accessor '.instance'
    # This ruby technique makes it so you don't have.
    # Could also be done with method_missing but this is a bit nicer
    # IMHO
    #
    class << self
      extend Forwardable
      def_delegators :instance, *Migrations.instance_methods(false)
    end
  end
  
  # This is the Grape REST API implementation
  class API < Grape::API
    # This makes it so you have to specifiy the API version in the
    # path string
    version 'v1', using: :path

    # Specifies that we're going to accept / send json
    format :json

    # We don't really need Namespaces in a simple example but this
    # shows how. You'll need them soon enough for something real
    # The namespace becomes the resource name and is in the path after
    # the version
    #
    namespace :migrations do
      # GET /vi/migrations
      get "/" do
        puts "Migrations.quantity: #{Migrations.quantity.inspect}" if $debug
        { count: Migrations.quantity }
      end

      # POST /vi/migrations/inc
      # If you supply an integer parameter in the body or the url named 'value'
      # it will add that ingeter to the current count
      # If you don't supply a parameter it increments the count by 1
      #
      post "/inc" do
        puts "POST /inc: params['value']: #{params[:value].inspect}" if $debug
        if params["value"]
          Migrations.quantity += params["value"].to_i
        else
          Migrations.quantity += 1
        end
      end
    end
  end
end
