module ApplicationHelper
  def edit_and_destroy_buttons(item)
    return unless current_user

    edit_button = link_to('Edit', url_for([:edit, item]), class: "btn btn-primary")
    back_link = link_to('Back', url_for(item.class), class: "btn btn-secondary")

    safe_join([edit_button, " | ", back_link], " ")
  end

  def round(number)
    number_with_precision(number, precision: 1)
  end
end
