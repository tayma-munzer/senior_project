# Generated by Django 5.1.4 on 2024-12-07 07:39

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0011_rename_building_type_building_type_buildingtype'),
    ]

    operations = [
        migrations.RenameField(
            model_name='building_type',
            old_name='buildingtype',
            new_name='building_type',
        ),
    ]
