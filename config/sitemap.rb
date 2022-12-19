require 'google/cloud/storage'

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.eligia.fr/"
SitemapGenerator::Sitemap.public_path = 'public/sitemaps'

SitemapGenerator::Sitemap.sitemaps_host = "https://storage.googleapis.com/eligia_sitemaps/"

SitemapGenerator::Sitemap.adapter = SitemapGenerator::GoogleStorageAdapter.new(
  bucket: 'eligia_sitemaps'
)

SitemapGenerator::Sitemap.create do
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host

  add price_pages_path
  add cgu_pages_path
  add cgs_pages_path
  add contrats_helps_path
  add documents_helps_path
  add recapitulatif_helps_path
  add tarifs_helps_path
  add helps_path
  add new_message_path
  add new_user_session_path
  add new_user_registration_path

  # Add '/blog'
  add blogposts_path, changefreq: 'daily'
  #
  # Add all articles:
  Blogpost.find_each do |article|
    add blogpost_path(article), lastmod: article.updated_at
  end
end
