module Jekyll
    class StravaEmbed < Liquid::Tag
        def initialize(tag_name, strava_id, tokens)
            super
            @strava_id = strava_id
          end
      
          def render(context)
            "<div class='strava-embed-placeholder' data-embed-type='activity' data-embed-id='#{@strava_id.strip}'></div><script src='https://strava-embeds.com/embed.js'></script>"
          end
    end
end

Liquid::Template.register_tag('strava_embed', Jekyll::StravaEmbed)