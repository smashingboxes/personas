module UrlHelper
  def make_absolute(uri)
    url = URI(uri)
    url.path = ''
    url.query = nil
    url
  end

  def rewrite(el, attr, base_url)
    if el[attr] =~ /^\//
      el[attr] = base_url.merge(el[attr]).to_s
    end
  end
end
