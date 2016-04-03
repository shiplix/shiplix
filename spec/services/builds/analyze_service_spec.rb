require "rails_helper"

describe Builds::AnalyzeService do
  let(:push_build) { create :push }
  subject(:service) { Builds::AnalyzeService.new(push_build) }

  let!(:namespaces_service) { class_double(Analyzers::NamespacesService, new: spy).as_stubbed_const }
  let!(:flog_service) { class_double(Analyzers::FlogService, new: spy).as_stubbed_const }
  let!(:flay_service) { class_double(Analyzers::FlayService, new: spy).as_stubbed_const }
  let!(:reek_service) { class_double(Analyzers::ReekService, new: spy).as_stubbed_const }
  let!(:brakeman_service) { class_double(Analyzers::BrakemanService, new: spy).as_stubbed_const }

  it "calls services in right order" do
    service.call

    expect(namespaces_service).to have_received(:new).with(push_build).ordered
    expect(flog_service).to have_received(:new).with(push_build).ordered
    expect(flay_service).to have_received(:new).with(push_build).ordered
    expect(reek_service).to have_received(:new).with(push_build).ordered
    expect(brakeman_service).to have_received(:new).with(push_build).ordered
  end
end
