"""Module 7.2: Movies Update and Deletes."""

from pathlib import Path
import mysql.connector
from dotenv import dotenv_values
from mysql.connector import errorcode


def show_films(cursor, title):
    """Display the film name, director, genre, and studio."""

    cursor.execute(
        """
        SELECT
            film.film_name AS Name,
            film.film_director AS Director,
            genre.genre_name AS Genre,
            studio.studio_name AS Studio
        FROM film
        INNER JOIN genre
            ON film.genre_id = genre.genre_id
        INNER JOIN studio
            ON film.studio_id = studio.studio_id
        ORDER BY film.film_name;
        """
    )

    films = cursor.fetchall()

    print(f"\n-- {title} --")

    for film in films:
        print(
            "Film Name: {}\n"
            "Director: {}\n"
            "Genre: {}\n"
            "Studio: {}\n".format(
                film[0],
                film[1],
                film[2],
                film[3],
            )
        )


# Read the database login information from the .env file
env_path = Path(__file__).parent / ".env"
secrets = dotenv_values(env_path)

config = {
    "user": secrets["USER"],
    "password": secrets["PASSWORD"],
    "host": secrets["HOST"],
    "database": secrets["DATABASE"],
    "raise_on_warnings": True,
}

db = None
cursor = None

try:
    db = mysql.connector.connect(**config)
    cursor = db.cursor()

    # Display the original film records
    show_films(cursor, "DISPLAYING FILMS")

    # Insert a new movie
    cursor.execute(
        """
        INSERT INTO film (
            film_name,
            film_releaseDate,
            film_runtime,
            film_director,
            studio_id,
            genre_id
        )
        VALUES (
            'Jaws',
            1975,
            124,
            'Steven Spielberg',
            (SELECT studio_id
             FROM studio
             WHERE studio_name = 'Universal Pictures'),
            (SELECT genre_id
             FROM genre
             WHERE genre_name = 'Horror')
        );
        """
    )

    db.commit()

    show_films(cursor, "DISPLAYING FILMS AFTER INSERT")

    # Update Alien from SciFi to Horror
    cursor.execute(
        """
        UPDATE film
        SET genre_id = (
            SELECT genre_id
            FROM genre
            WHERE genre_name = 'Horror'
        )
        WHERE film_name = 'Alien';
        """
    )

    db.commit()

    show_films(cursor, "DISPLAYING FILMS AFTER UPDATE")

    # Delete Gladiator
    cursor.execute(
        """
        DELETE FROM film
        WHERE film_name = 'Gladiator';
        """
    )

    db.commit()

    show_films(cursor, "DISPLAYING FILMS AFTER DELETE")

except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("The supplied username or password is invalid.")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("The specified database does not exist.")
    else:
        print(f"MySQL error: {err}")

finally:
    if cursor is not None:
        cursor.close()

    if db is not None and db.is_connected():
        db.close()
        print("\nDatabase connection closed.")