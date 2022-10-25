class FileTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless record.document.nil? || value.nil?
      case record.document.file_type
      when 'iban'
        record.errors.add attribute, (options[:message] || "IBAN invalide") unless
        value.gsub(' ', '') =~ /[A-Z]{2}(?:[ ]?[0-9]){18,25}/i || value.empty?
      when 'email'
        record.errors.add attribute, (options[:message] || "email invalide") unless
        value.gsub(' ', '') =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i || value.empty?
      when 'compteur_gaz'
        record.errors.add attribute, (options[:message] || "Relevé invalide") unless
        value =~ /\A\d{5}\z/
      when 'compteur_elec'
        # PDL (point de livraison ou numéro de compteur)
        record.errors.add attribute, (options[:message] || "Relevé invalide") unless
        value =~ /\A\d{14}\z/
      when 'compteur_eau'
        # record.errors.add attribute, (options[:message] || "Relevé invalide") unless
        # value =~ /^FR\d{12}[A-Z0-9]{11}\d{2}$/i || value.empty?
      when 'telephone_mobile', 'telephone_fixe'
        record.errors.add attribute, (options[:message] || "Numéro invalide") unless
        value.gsub(' ', '') =~ /^(\(\+33\)|0|\+33|0033)[1-9]([0-9]{8})$/ || value.empty?
      end
    end
  end
end
