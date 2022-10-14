module ApplicationHelper
  def default_meta_tags
    {
      site: 'Résiliations suite au décès',
      title: 'Eligia',
      reverse: true,
      separator: '-',
      description: "Résiliez d'un seul coup tous les abonnements d'un proche disparu. Simplifier les démarches pour se concentrer sur le deuil.",
      keywords: 'résiliation, décès, deuil, abonnement',
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      icon: [
        { href: image_url('eligia-favicon-32x32.png'), rel: 'icon', sizes: '32x32', type: 'image/png' }
      ],
      og: {
        site_name: 'eligia.fr',
        title: 'Eligia',
        description: "Résiliez d'un seul coup tous les abonnements d'un proche disparu. Simplifier les démarches pour se concentrer sur le deuil.",
        type: 'website',
        url: request.original_url,
        image: image_url('eligia-meta-tag.png')
      }
    }
  end
end
