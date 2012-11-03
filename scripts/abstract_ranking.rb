# -*- encoding: utf-8 -*-

class AbstractRanking

  def initialize
    super
  end

  def register_apps(apps)
    apps.each do |app|
      next unless app["app_id"]
      if RankingApps.filter(:app_id => app["app_id"]).count == 0
        RankingApps.create(
          :app_id     => app["app_id"],
          :name       => app["name"],
          :genre      => app["genre"],
          :developer  => app["developer"],
          :url        => app["url"],
          :thumbnail  => app["thumbnail"],
          :created_at => Time.now
        )
      end
    end
  end

  def register_rankings(apps, opt)
    if opt[:date]==nil || opt[:date].empty?
      now = Time.now
      ranking_date = Time.local(now.year, now.month, now.day)
    else
      ranking_date = Time.parse(opt[:date])
    end

    return unless RankingRecords.filter(:date => ranking_date,
                                        :store_type => opt[:store_type]).count == 0

    apps.each do |app|
      next unless app["app_id"]
      RankingRecords.create(
        :app_id     => app["app_id"],
        :rank       => app["rank"].to_i,
        :rating     => app["rating"],
        :date       => ranking_date,
        :genre      => opt["genre"],
        :store_type => app["store_type"],
        :created_at => Time.now
      )
    end
  end

end
