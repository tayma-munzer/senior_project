# Generated by Django 5.1.4 on 2024-12-07 07:14

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0010_rename_buildingstyle_building_style_building_style'),
    ]

    operations = [
        migrations.RenameField(
            model_name='building_type',
            old_name='building_type',
            new_name='buildingtype',
        ),
    ]