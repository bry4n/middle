require 'securerandom'
require 'hashie'

class MockClass < Hashie::Dash

  property :persisted, default: false

  def self.create
    new(persisted: true)
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
