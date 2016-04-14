module Flay
  class DirtyClass
    def x
      if params[:name] && params[:name] != ''
        conditions << '(lower(name) like :name)'
        placeholders[:name] = '%' + params[:name].downcase + '%'
      end
    end

    def y
      if params[:name] && params[:name] != ''
        conditions << '(lower(name) like :name)'
        placeholders[:name] = '%' + params[:name].downcase + '%'
      end
    end
  end
end
