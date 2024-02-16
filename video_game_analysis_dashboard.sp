dashboard "video_game_analysis_dashboard" {
  title = "Video Game Analysis Dashboard"

  # Container: Overview
  container {
    title = "Overview"

    # Card: Total Games
    card {
      query = query.total_games
      width = 3
      type  = "info"
    }

    # Card: Total Developers
    card {
      query = query.total_developers
      width = 3
      type  = "info"
    }

    # Card: Total Publishers
    card {
      query = query.total_publishers
      width = 3
      type  = "info"
    }

    # Card: Total Platforms Card
    card {
      query = query.total_platforms
      width = 3
      type  = "info"
    }
  }

  # Container: Game and developer Analysis
  container {
    title = "Game and developer Analysis"

    # Chart: Top 10 Games by User Score
    chart {
      type  = "column"
      title = "Top 10 Games by User Score"
      query = query.top_10_games_by_user_score
      width = 6
      series "user_score" {
        title = "User Score"
        color = "darkblue"
      }
    }

    # Chart: Top 10 Games by User Ratings
    chart {
      type  = "column"
      title = "Top 10 Games by User Ratings Count"
      query = query.top_10_games_by_user_ratings_count
      width = 6
      series "user_ratings_count" {
        title = "User Ratings Count"
        color = "red"
      }
    }
  }

  # Container: Genre and Platform Analysis
  container {
    title = "Genre and Platform Analysis"

    # Chart: Genre Distribution
    chart {
      type  = "donut"
      title = "Genre Distribution"
      query = query.genre_distribution
      width = 6
    }

    # Chart: Average Platform Meta Score per Genre
    chart {
      type  = "line"
      title = "Average Platform Meta Score per Genre"
      query = query.average_platform_meta_score_per_genre
      width = 6
    }
  }
  # Container: Top Developers and Publishers
  container {
    title = "Top Developers and Publishers"

    # Chart: Top 10 Developers by Game Count
    chart {
      type  = "column"
      title = "Top 10 Developers by Game Count"
      query = query.top_10_developers_by_game_count
      width = 6

      series "Game Count" {
        title = "Game Count"
        color = "blue"
      }
    }

    # Chart: Top 10 Publishers by Game Count
    chart {
      type  = "column"
      title = "Top 10 Publishers by Game Count"
      query = query.top_10_publishers_by_game_count
      width = 6

      series "Game Count" {
        title = "Game Count"
        color = "green"
      }
    }
  }
}

query "total_games" {
  sql = <<-EOQ
    select
      count(*) as "Total Games"
    from
      game_data;
  EOQ
}

query "total_developers" {
  sql = <<-EOQ
    select
      count(distinct developer) as "Total Developers"
    from
      game_data;
  EOQ
}

query "total_publishers" {
  sql = <<-EOQ
    select
      count(distinct publisher) as "Total Publishers"
    from
      game_data;
  EOQ
}

query "total_platforms" {
  sql = <<-EOQ
    select count(distinct substring_index(
        substring_index(
          substring_index(`platforms_info`, "'Platform': '", -1),
          "'",
          1
        ),
        "'",
        1
      )) as "Total Platforms"
    from game_data
    where `platforms_info` like "%'Platform'%";
  EOQ
}

query "top_10_games_by_user_score" {
  sql = <<-EOQ
    select
      title,
      user_score
    from
      game_data
    order by
      user_score desc
    limit 10;
  EOQ
}

query "top_10_games_by_user_ratings_count" {
  sql = <<-EOQ
    select
      title,
      user_ratings_count
    from
      game_data
    order by
      user_ratings_count desc
    limit 10;
  EOQ
}

query "genre_distribution" {
  sql = <<-EOQ
    select
      genres,
      count(*) as "Number Of Games"
    from
      game_data
    group by
      genres
    order by
      "Number Of Games" desc;
  EOQ
}

query "top_10_developers_by_game_count" {
  sql = <<-EOQ
    select
      developer,
      count(*) as "Game Count"
    from
      game_data
    where
      developer is not null
    group by
      developer
    order by
      "Game Count" desc
    limit 10;
  EOQ
}

query "top_10_publishers_by_game_count" {
  sql = <<-EOQ
    select
      publisher,
      count(*) as "Game Count"
    from
      game_data
    where
      publisher is not null
    group by
      publisher
    order by
      "Game Count" desc
    limit 10;
  EOQ
}

query "average_platform_meta_score_per_genre" {
  sql = <<-EOQ
    select
      genres,
      avg(cast(substring_index(substring_index(substring_index(`platforms_info`, "'Platform Metascore': '", -1), "'", 1), "'", 1) as unsigned)) as "Average Platform Meta Score"
    from
      game_data
    where
      `platforms_info` like "%'Platform Metascore'%"
      and genres is not null
    group by
      genres
    order by
      "Average Meta Score" desc;
  EOQ
}