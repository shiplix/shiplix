class PagesController < ApplicationController
  include HighVoltage::StaticPage

  layout "front"
  skip_before_action :authenticate

  before_action :set_meta, only: :show

  private

  def set_meta
    default = params[:id].humanize

    self.custom_header = I18n.t(params[:id], scope: 'front.header', default: default)
    self.custom_title = I18n.t(params[:id], scope: 'front.title', default: default)
  end
end
