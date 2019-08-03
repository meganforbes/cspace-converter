module DataObjectsHelper

  def current_page_params
    request.params.slice('batch', 'errors', 'page')
  end

  def object_label(object)
    "#{object.id} #{object.import_batch} #{object.converter_module} #{object.converter_profile}"
  end

end
