# Generated by Django 5.1.4 on 2024-12-23 09:35

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0017_alter_artwork_poster_alter_artwork_gallery_poster_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='location_videos',
            name='video',
            field=models.FileField(blank=True, upload_to='videos/'),
        ),
    ]
