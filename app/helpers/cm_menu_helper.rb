module CmMenuHelper
  def render_custom_menu_for_admin(menu_items, project=nil)
    return nil if menu_items.blank?
    chain = []


    html = '<ul class="dd-list">'

    menu_items.each do |it|
      while chain.size > 0 && !it.is_descendant_of?(chain.last)
        html << '</ul></li>'
        chain.pop
      end

      html << '<li class="dd-item" data-type="' + it.class.name + '" data-id="nst-' + it.id.to_s + '"'
      if it.code.present?
        html << ' data-code="' + it.code + '"'
      else
        html += ' data-caption="' + it.caption.to_s + '"'
        html += ' data-custom_url="' + it.custom_url.to_s + '"'
        html += ' data-options_class="' + (it.options || {})[:class].to_s + '"'
        html += ' data-logged="' + (it.logged ? 'true' : 'false') + '"'
        html += ' data-visibility="' + it.visibility.to_s + '"'
        html += ' data-roles="' + it.cm_roles.map(&:role_id).join(',') + '"'
      end
      html << '>'
      html << render_menu_item_content(it, project)

      if it.rgt - it.lft != 1
        html << '<ul class="dd-list">'
        chain << it
      else
        html << '</li>'
      end
    end

    html << '</ul></li>' * chain.size
    html << '</ul>'
    html.html_safe
  end

  def render_menu_item_content(item, project=nil)
    html = ''
    html << '<div class="dd-content dd-buttunable">'
    html << '<div class="dd-handle"></div>'

    item_label = item.item_label
    if item_label.blank?
      html << l(:label_cm_not_available)
    else
      html << item_label
    end

    html << '<div class="dd-right">'
    html << link_to('', '#', class: 'icon icon-edit cm-edit link_to_modal') if item.can_edit?
    html << link_to('', '#', class: 'icon icon-del cm-del') if item.rgt - item.lft == 1
    html << '</div>'

    html << '</div>'
    html.html_safe
  end
end