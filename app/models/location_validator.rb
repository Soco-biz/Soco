class LocationValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value == 0 || value.nil?
      record.errors.add(attribute, 'は0以外かつFloatで指定してください')
    end
  end
end