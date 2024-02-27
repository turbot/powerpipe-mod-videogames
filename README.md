# Video Game Analysis Mod for PowerPipe

Analyze video games data using MySQL and PowerPipe.

![video-game-analysis-dashboard](https://github.com/turbot/powerpipe-mod-video-game/assets/72413708/4cfc4e02-4ccd-49a3-9c60-d73594c6d108)

## Getting Started

### Installation

Download and install Powerpipe (https://powerpipe.io/downloads) and MySQL (https://dev.mysql.com/downloads/mysql/). Or use Brew:

```sh
brew install turbot/tap/powerpipe
brew install turbot/tap/mysql
```

Clone:

```sh
git clone https://github.com/turbot/powerpipe-mod-video-game.git
cd powerpipe-mod-video-game
```
### Setup Data

Download the dataset:

- Download the [Video Games Dataset](https://www.kaggle.com/datasets/beridzeg45/video-games) (requires signup with [Kaggle](https://www.kaggle.com/))

Enable MySQL server to read from local file:

```sh
echo "local_infile = 1" >> /opt/homebrew/etc/my.cnf
```

Start MySQL server:

```sh
brew services start mysql
```

Create a MySQL database:

```sh
mysql -u root
create database video_game;
```

Use the newly created database:

```sh
use video_game;
```

Create a table;

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
load data local infile '/path/to/your/all_video_games.csv'
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

Clone:

```sh
git clone https://github.com/turbot/powerpipe-mod-youtuber.git
cd powerpipe-mod-youtuber
```

## Usage

Run the dashboard and specify the DB connection string:

```sh
powerpipe server --database mysql://root@/video_game
```

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Powerpipe](https://powerpipe.io) is a product produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). It is distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #powerpipe on Slack →](https://powerpipe.io/community/join)**

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Powerpipe](https://github.com/turbot/powerpipe/labels/help%20wanted)
- [Video Game Data Mod](https://github.com/turbot/powerpipe-mod-video-game/labels/help%20wanted)
