require 'securerandom'

class MockClass

  attr_accessor :persisted

  def self.create
    obj = new
    obj.save
    obj
  end

  def initialize(*args)
    options = args.extract_options!
    @persisted = options[:persisted] || false
  end

  def id
    @id ||= SecureRandom.uuid
  end

  def save
    self.persisted = true
  end

  def new_record?
    !persisted?
  end

  def persisted?
    self.persisted == true
  end

end
