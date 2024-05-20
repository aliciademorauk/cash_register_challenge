module InputValidation

  # Method to validate user inputs for classes that have validation rules.
  def validated?(key, value, validation_rules)
    value.to_s.match(validation_rules[key])
  end

end