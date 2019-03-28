module CanApplyFilters
  def apply_filters
    params[:filterrific] ||= { sorted_by: 'updated_at_desc' }
    @filterrific = initialize_filterrific(Camp, params[:filterrific].merge(
      active: true,
      not_hidden: !(current_user&.admin? || current_user&.guide?),
      is_cocreation: is_cocreation?
    ), select_options: {
        tagged_with: Camp.options_for_tags
    })
    @camps = @filterrific&.find&.page(params[:page])
  end

  private

  def is_cocreation?
    false
  end
end
