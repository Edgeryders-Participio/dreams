ActiveAdmin.register Camp do

  scope :active, default: true do |dreams|
    dreams.active(true)
  end
  scope :displayed_with_tags, default: false
  scope("Public") { |scope| scope.where(is_public: true) }
  scope("Private") { |scope| scope.where(is_public: false) }
  scope("Inactive") { |scope| scope.where(active: false) }

  remove_filter *%i(tag_taggings taggings base_tags)
  index do
    selectable_column

    (Camp.column_names - EXCLUDED).each do |cn|
      column I18n.t("activerecord.attributes.camp.#{cn}"), cn
    end
    %i(manager_name manager_email manager_phone).each do |f|
      column(f) { |camp|
        camp[f].is_a?(Array) ? camp[f].join(', ') : camp[f]
      }
    end

    column(:tags) { |camp|
      camp.tags.collect(&:name).join(', ')
    }
  end

  csv do
    (Camp.column_names - EXCLUDED).each do |cn|
      column cn
    end
    %i(manager_name manager_email manager_phone).each do |f|
      column(f) { |camp|
        camp[f].is_a?(Array) ? camp[f].join(', ') : camp[f]
      }
    end
    Camp.tag_counts.map(&:name).sort_by(&:downcase).each do |t|
      column(t) { |camp|
        camp.tags.collect(&:name).include?(t)
      }
    end
  end

  member_action :show do
      @camp = Camp.includes(versions: :item).find(params[:id])
      @versions = @camp.versions 
      @camp = @camp.versions[params[:version].to_i].reify if params[:version]
      show!
  end

  member_action :history do
    @camp = Camp.find(params[:id])
    @versions = PaperTrail::Version.where(item_type: 'Camp', item_id: @camp.id)
    render "layouts/history"
  end

  sidebar :versionate, :partial => "layouts/version", :only => :show

  permit_params do |params|
    Camp.columns.map(&:name) - %w(id updated_at created_at)
  end
end
