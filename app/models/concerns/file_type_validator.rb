class FileTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless record.document.nil? || value.nil?
      case record.document.file_type
      when 'iban'
        record.errors.add attribute, (options[:message] || "IBAN incorrect") unless
        value.gsub(' ', '') =~ /^FR\d{12}[A-Z0-9]{11}\d{2}$/i || value.empty?
      when 'compteur_gaz'
        # record.errors.add attribute, (options[:message] || "Relevé incorrect") unless
        # value =~ /^FR\d{12}[A-Z0-9]{11}\d{2}$/i
      when 'compteur_elec'
        # record.errors.add attribute, (options[:message] || "Relevé incorrect") unless
        # value =~ /^FR\d{12}[A-Z0-9]{11}\d{2}$/i
      when 'compteur_eau'
        # record.errors.add attribute, (options[:message] || "Relevé incorrect") unless
        # value =~ /^FR\d{12}[A-Z0-9]{11}\d{2}$/i || value.empty?
      when 'telephone_mobile'
        record.errors.add attribute, (options[:message] || "Numéro incorrect") unless
        value =~ /(\(\+33\)|0|\+33|0033)[1-9]([0-9]{8}|([0-9\- ]){12})/ || value.empty?
      when 'telephone_fixe'
        record.errors.add attribute, (options[:message] || "Numéro incorrect") unless
        value =~ /(\(\+33\)|0|\+33|0033)[1-9]([0-9]{8}|([0-9\- ]){12})/ || value.empty?
      end
    end
  end
end
