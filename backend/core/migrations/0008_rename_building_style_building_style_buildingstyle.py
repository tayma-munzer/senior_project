# Generated by Django 5.1.4 on 2024-12-06 13:08

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0007_alter_artwork_done'),
    ]

    operations = [
        migrations.RenameField(
            model_name='building_style',
            old_name='building_style',
            new_name='buildingStyle',
        ),
    ]
