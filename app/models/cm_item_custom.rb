class CmItemCustom < CmItem

  validates :caption, presence: true

  def item_text(view, opts, *args)
    cl = opts.delete(:class)
    opts = (self.options || {}).merge(opts)
    opts[:class] = opts[:class].to_s + ' ' + cl if cl.present?

    html = self.custom_url ? view.link_to("<span>#{self.caption}</span>".html_safe, Redmine::Utils.relative_url_root + self.custom_url, opts) : "<span>#{self.caption}</span>".html_safe

    if Redmine::Plugin.installed?(:ajax_counters) && Redmine::Plugin.installed?(:extra_queries) && self.custom_url.include?("issues?query_id=")
      id = self.custom_url.scan(/.+=([0-9]+)$/).flatten.first
      html << User.current.ajax_counter(Redmine::Utils.relative_url_root.to_s + '/extra_queries/eq_count/' + id, {period: 300, css: 'count ac_light'}).html_safe
    end
    html
  end

  def self.item_label(code)
    ''
  end

  def item_label
    self.caption
  end

  def can_edit?
    User.current.admin?
  end

  def visible?(project=nil, from_parent=false)
    return false unless (!self.logged || User.current.logged?) && (self.visibility != CmItem::VISIBILITY_ADMIN || User.current.admin?)

    super(project, from_parent)
  end
end
