from .base import *
ROOT_URLCONF = 'ecommerce.urls'
DATABASES = {
    # 'default': dj_database_url.parse(os.environ.get("DATABASE_URL","postgresql://testdb_4qio_user:dyMZeIr3w5cpywknfyPE6yHLjK4pydN7@dpg-cvo33l49c44c73bhvg40-a.oregon-postgres.render.com/testdb_4qio"))
     'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',  # BASE_DIR should be defined in your base settings
    }
}
 