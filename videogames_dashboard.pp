dashboard "videogames" {

  title         = "Video Games Dashboard"
  documentation = file("./docs/videogames_dashboard.md")

  container {
    title = "Overview"

    card {
      query = query.videogames_total
      width = 3
      type  = "info"
    }

    card {
      query = query.videogames_total_developers
      width = 3
      type  = "info"
    }

    card {
      query = query.videogames_total_publishers
      width = 3
      type  = "info"
    }

    card {
      query = query.videogames_total_platforms
      width = 3
      type  = "info"
    }
  }

  container {
    title = "Game and Developer Analysis"

    chart {
      type  = "column"
      title = "Top 10 Games by User Score"
      query = query.videogames_top_10_by_user_score
      width = 6
      series "user_score" {
        title = "User Score"
        color = "darkblue"
      }
    }

    chart {
      type  = "column"
      title = "Top 10 Games by User Ratings Count"
      query = query.videogames_top_10_by_user_ratings_count
      width = 6
      series "user_ratings_count" {
        title = "User Ratings Count"
        color = "red"
      }
    }
  }

  container {
    title = "Genre and Platform Analysis"

    chart {
      type  = "donut"
      title = "Top 10 Genre Distribution"
      query = query.videogames_top_10_genre_distribution
      width = 6
    }

    chart {
      type  = "column"
      title = "Top 10 Average Platform Meta Score per Genre"
      query = query.videogames_average_platform_meta_score_per_genre
      width = 6
    }
  }

  container {
    title = "Top Developers and Publishers"

    chart {
      type  = "column"
      title = "Top 10 Developers by Game Count"
      query = query.videogames_top_10_developers_by_game_count
      width = 6

      series "Game Count" {
        title = "Game Count"
        color = "blue"
      }
    }

    chart {
      type  = "column"
      title = "Top 10 Publishers by Game Count"
      query = query.videogames_top_10_publishers_by_game_count
      width = 6

      series "Game Count" {
        title = "Game Count"
        color = "green"
      }
    }
  }
}

# Chart Queries

query "videogames_total" {
  sql = <<-EOQ
    select
      count(*) as "Total Games"
    from
      game_data;
  EOQ
}

query "videogames_total_developers" {
  sql = <<-EOQ
    select
      count(distinct developer) as "Total Developers"
    from
      game_data;
  EOQ
}

query "videogames_total_publishers" {
  sql = <<-EOQ
    select
      count(distinct publisher) as "Total Publishers"
    from
      game_data;
  EOQ
}

query "videogames_total_platforms" {
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

# Chart Queries

query "videogames_top_10_by_user_score" {
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

query "videogames_top_10_by_user_ratings_count" {
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

query "videogames_top_10_genre_distribution" {
  sql = <<-EOQ
    select
      genres,
      count(*) as "Number Of Games"
    from
      game_data
    group by
      genres
    order by
      count(*) desc
    limit 10;
  EOQ
}

query "videogames_average_platform_meta_score_per_genre" {
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
      "Average Platform Meta Score" desc
    limit 10;
  EOQ
}

query "videogames_top_10_developers_by_game_count" {
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
      count(*) desc
    limit 10;
  EOQ
}

query "videogames_top_10_publishers_by_game_count" {
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
      count(*) desc
    limit 10;
  EOQ
}