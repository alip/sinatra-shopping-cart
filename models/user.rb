class User < ActiveRecord::Base
  validates :name, :presence => true
  validates :username, :presence => true, :uniqueness => true
  validates :email, :presence => true, :uniqueness => true

  has_secure_password

  include Swagger::Blocks
  swagger_model :User do
    key :id, :User
    property :id do
      key :type, :integer
      key :format, :int64
      key :required, :true
    end
    property :name do
      key :type, :string
      key :required, :true
    end
    property :username do
      key :type, :string
      key :required, :true
    end
    property :name do
      key :type, :string
      key :required, :true
    end
  end
end
