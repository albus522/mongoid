# encoding: utf-8
module Mongoid #:nodoc:

  # This module defines the finder methods that hang off the document at the
  # class level.
  module Finders

    # Delegate to the criteria methods that are natural for creating a new
    # criteria.
    critera_methods = [ :all_in, :all_of, :any_in, :any_of, :asc, :ascending,
                        :avg, :desc, :descending, :excludes, :extras,
                        :includes, :limit, :max, :min, :not_in, :only,
                        :order_by, :search, :skip, :sum, :without, :where,
                        :update, :update_all, :near ]
    delegate(*(critera_methods.dup << { :to => :criteria }))

    # Find all documents that match the given conditions.
    #
    # @example Find all matching documents given conditions.
    #   Person.all(:conditions => { :attribute => "value" })
    #
    # @param [ Array ] args The conditions with options.
    #
    # @return [ Criteria ] The matching documents.
    def all
      criteria
    end

    # Returns a count of records in the database.
    # If you want to specify conditions use where.
    #
    # @example Get the count of matching documents.
    #   Person.count
    #   Person.where(title: "Sir").count
    #
    # @return [ Integer ] The number of matching documents.
    def count
      criteria.count
    end

    # Returns true if count is zero
    #
    # @example Are there no saved documents for this model?
    #   Person.empty?
    #
    # @return [ true, false ] If the collection is empty.
    def empty?
      count == 0
    end

    # Returns true if there are on document in database based on the
    # provided arguments.
    #
    # @example Do any documents exist for the conditions?
    #   Person.exists?(:conditions => { :attribute => "value" })
    #
    # @param [ Array ] args The conditions.
    def exists?
      criteria.exists?
    end

    # Find a +Document+ in several different ways.
    #
    # If a +String+ is provided, it will be assumed that it is a
    # representation of a Mongo::ObjectID and will attempt to find a single
    # +Document+ based on that id. If a +Symbol+ and +Hash+ is provided then
    # it will attempt to find either a single +Document+ or multiples based
    # on the conditions provided and the first parameter.
    #
    # @example Find a single document by an id.
    #   Person.find(BSON::ObjectId)
    #
    # @param [ Array ] args An assortment of finder options.
    #
    # @return [ Document, nil, Criteria ] A document or matching documents.
    def find(*args)
      criteria.find(*args)
    end

    # Find the first +Document+ given the conditions, or creates a new document
    # with the conditions that were supplied.
    #
    # @example Find or create the document.
    #   Person.find_or_create_by(:attribute => "value")
    #
    # @param [ Hash ] attrs The attributes to check.
    #
    # @return [ Document ] A matching or newly created document.
    def find_or_create_by(attrs = {}, &block)
      find_or(:create, attrs, &block)
    end

    # Find the first +Document+ given the conditions, or initializes a new document
    # with the conditions that were supplied.
    #
    # @example Find or initialize the document.
    #   Person.find_or_initialize_by(:attribute => "value")
    #
    # @param [ Hash ] attrs The attributes to check.
    #
    # @return [ Document ] A matching or newly initialized document.
    def find_or_initialize_by(attrs = {}, &block)
      find_or(:new, attrs, &block)
    end

    # Find the first +Document+ given the conditions, or raises
    # Mongoid::Errors::DocumentNotFound
    #
    # @example Find the document by attribute other than id
    #   Person.find_by(:username => "superuser")
    #
    # @param [ Hash ] attrs The attributes to check.
    #
    # @raise [ Errors::DocumentNotFound ] If no document found.
    #
    # @return [ Document ] A matching document.
    #
    # @since 3.0.0
    def find_by(attrs = {})
      where(attrs).first || raise(Errors::DocumentNotFound.new(self, attrs))
    end

    # Find the first +Document+ given the conditions.
    #
    # @example Find the first document.
    #   Person.first(:conditions => { :attribute => "value" })
    #
    # @param [ Array ] args The conditions with options.
    #
    # @return [ Document ] The first matching document.
    def first
      criteria.first
    end

    # Find the last +Document+ given the conditions.
    #
    # @example Find the last document.
    #   Person.last(:conditions => { :attribute => "value" })
    #
    # @param [ Array ] args The conditions with options.
    #
    # @return [ Document ] The last matching document.
    def last
      criteria.last
    end

    protected

    # Find the first object or create/initialize it.
    #
    # @example Find or perform an action.
    #   Person.find_or(:create, :name => "Dev")
    #
    # @param [ Symbol ] method The method to invoke.
    # @param [ Hash ] attrs The attributes to query or set.
    #
    # @return [ Document ] The first or new document.
    def find_or(method, attrs = {}, &block)
      where(attrs).first || send(method, attrs, &block)
    end
  end
end
