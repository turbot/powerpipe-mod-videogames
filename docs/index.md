# Video Games Mod

View dashboards to analyze video game platforms, developers, industry trends, and more.

<img src="https://raw.githubusercontent.com/turbot/powerpipe-mod-videogames/main/docs/videogames_dashboard_screenshot.png" width="50%" type="thumbnail"/>

## Documentation

- **[Dashboards →](https://hub.powerpipe.io/mods/turbot/videogames/dashboards)**

## Getting Started

### Installation

Download and install Powerpipe (https://powerpipe.io/downloads) and MySQL (https://dev.mysql.com/downloads/mysql/). Or use Brew:

```sh
brew install turbot/tap/powerpipe
brew install turbot/tap/mysql
```

Install the mod:

```sh
mkdir dashboards
cd dashboards
powerpipe mod init
powerpipe mod install github.com/turbot/powerpipe-mod-videogames
```

### Configure Database

Download the [Video Games Dataset](https://www.kaggle.com/datasets/beridzeg45/video-games/versions/2) and extract it in the current directory:

```sh
unzip ~/Downloads/archive.zip
```

Start MySQL server:

```sh
mysqld
```

Connect to MySQL:

```sh
mysql -u root --local-infile=1
```

Create a database:

```sh
create database video_game;
use video_game;
```

Create a table:

```sh
create table game_data (
  title varchar(255),
  release_date date,
  developer varchar(255),
  publisher varchar(255),
  genres varchar(255),
  genres_splitted varchar(255),
  product_rating varchar(255),
  user_score float,
  user_ratings_count int,
  platforms_info text
);
```

Load the dataset into the table:

```sh
load data local infile 'all_video_games.csv'
into table game_data
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(@title, @release_date, @developer, @publisher, @genres, @genres_splitted, @product_rating, @user_score, @user_ratings_count, @platforms_info)
set
   title = @title,
   release_date = str_to_date(@release_date, '%m/%d/%Y'),
   developer = @developer,
   publisher = @publisher,
   genres = @genres,
   genres_splitted = @genres_splitted,
   product_rating = @product_rating,
   user_score = nullif(@user_score, ''),
   user_ratings_count = nullif(@user_ratings_count, ''),
   platforms_info = @platforms_info;
```

### Browsing Dashboards

Start the dashboard server with the DB connection string:

```sh
powerpipe server --database mysql://root@/video_game
```

Browse and view your dashboards at **http://localhost:9033**.

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Powerpipe](https://powerpipe.io) is a product produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). It is distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #powerpipe on Slack →](https://powerpipe.io/community/join)**

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Powerpipe](https://github.com/turbot/powerpipe/labels/help%20wanted)
- [Video Games Mod](https://github.com/turbot/powerpipe-mod-video-game/labels/help%20wanted)
