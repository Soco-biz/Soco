class LocationValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value == 0 || !value.kind_of?(Float)
      record.errors.add(attribute, 'はfloat型にしてください')
    end
  end
end