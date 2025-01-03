# Generated by Django 5.1.2 on 2024-11-24 20:04

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0001_initial'),
    ]

    operations = [
        migrations.RenameField(
            model_name='actor',
            old_name='current_country_id',
            new_name='current_country',
        ),
        migrations.RenameField(
            model_name='actor_acting_types',
            old_name='acting_type_id',
            new_name='acting_type',
        ),
        migrations.RenameField(
            model_name='actor_acting_types',
            old_name='actor_id',
            new_name='actor',
        ),
        migrations.RenameField(
            model_name='artwork',
            old_name='director_id',
            new_name='director',
        ),
        migrations.RenameField(
            model_name='artwork_actors',
            old_name='actor_id',
            new_name='actor',
        ),
        migrations.RenameField(
            model_name='artwork_actors',
            old_name='artwork_id',
            new_name='artwork',
        ),
        migrations.RenameField(
            model_name='artwork_actors',
            old_name='role_type_id',
            new_name='role_type',
        ),
        migrations.RenameField(
            model_name='artwork_gallery',
            old_name='actor_id',
            new_name='actor',
        ),
        migrations.RenameField(
            model_name='artwork_gallery',
            old_name='role_type_id',
            new_name='role_type',
        ),
        migrations.RenameField(
            model_name='booking_dates',
            old_name='location_id',
            new_name='location',
        ),
        migrations.RenameField(
            model_name='favoraites',
            old_name='location_id',
            new_name='location',
        ),
        migrations.RenameField(
            model_name='favoraites',
            old_name='user_id',
            new_name='user',
        ),
        migrations.RenameField(
            model_name='filming_location',
            old_name='building_owner_id',
            new_name='building_owner',
        ),
        migrations.RenameField(
            model_name='filming_location',
            old_name='building_style_id',
            new_name='building_style',
        ),
        migrations.RenameField(
            model_name='filming_location',
            old_name='building_type_id',
            new_name='building_type',
        ),
        migrations.RenameField(
            model_name='location_photos',
            old_name='location_id',
            new_name='location',
        ),
        migrations.RenameField(
            model_name='location_videos',
            old_name='location_id',
            new_name='location',
        ),
        migrations.RenameField(
            model_name='official_document',
            old_name='actor_id',
            new_name='actor',
        ),
        migrations.RenameField(
            model_name='scene_actors',
            old_name='actor_id',
            new_name='actor',
        ),
        migrations.RenameField(
            model_name='scene_actors',
            old_name='scene_id',
            new_name='scene',
        ),
        migrations.RenameField(
            model_name='scenes',
            old_name='artwork_id',
            new_name='artwork',
        ),
        migrations.RenameField(
            model_name='scenes',
            old_name='location_id',
            new_name='location',
        ),
    ]
