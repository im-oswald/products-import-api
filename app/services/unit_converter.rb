# frozen_string_literal: true

class UnitConverter
  SUPPORTED_UNITS = I18n.t('units.defaults').with_indifferent_access.freeze

  attr_reader :value, :unit, :conversion_unit

  def self.call(value, unit, conversion_unit)
    new(value: value, unit: unit, conversion_unit: conversion_unit).call
  end

  def initialize(value:, unit:, conversion_unit:)
    @value = value
    @unit = unit.to_s
    @conversion_unit = conversion_unit.to_s
  end

  def call
    return unless value && unit && conversion_unit

    convert
  rescue StandardError => e
    Exceptions.print_error e
  end

  private

  def convert
    response = sanitize_value.convert_to(conversion_unit).to_s('%0.3f')

    response&.split(' ')&.first.to_f
  end

  def sanitize_value
    return prepare_unit(unit) if SUPPORTED_UNITS.keys.include?(unit)

    supported_unit = SUPPORTED_UNITS.find{ |key, value| value.include?(unit) }&.first

    raise "Unsupported format for conversion" unless supported_unit

    prepare_unit(supported_unit)
  end

  def prepare_unit(unit)
    Unit.new("#{value}#{unit}")
  end
end
