require 'rails_helper'

describe CustomWizard::Validator do
  fab!(:user) { Fabricate(:user) }
  
  let(:template) {
    JSON.parse(File.open(
      "#{Rails.root}/plugins/discourse-custom-wizard/spec/fixtures/wizard.json"
    ).read).with_indifferent_access
  }
  
  let(:after_time) {
    JSON.parse(File.open(
      "#{Rails.root}/plugins/discourse-custom-wizard/spec/fixtures/wizard/after_time.json"
    ).read).with_indifferent_access
  }
  
  it "validates valid templates" do
    expect(
      CustomWizard::Validator.new(template).perform
    ).to eq(true)
  end
  
  it "invalidates templates without required attributes" do
    template.delete(:id)
    expect(
      CustomWizard::Validator.new(template).perform
    ).to eq(false)
  end
  
  it "invalidates templates with duplicate ids if creating a new template" do
    CustomWizard::Template.save(template)
    expect(
      CustomWizard::Validator.new(template, create: true).perform
    ).to eq(false)
  end
  
  it "validates after time settings" do
    template[:after_time] = after_time[:after_time]
    template[:after_time_scheduled] = after_time[:after_time_scheduled]
    expect(
      CustomWizard::Validator.new(template).perform
    ).to eq(true)
  end
  
  it "invalidates invalid after time settings" do
    template[:after_time] = after_time[:after_time]
    template[:after_time_scheduled] = "not a time"
    expect(
      CustomWizard::Validator.new(template).perform
    ).to eq(false)
  end
end