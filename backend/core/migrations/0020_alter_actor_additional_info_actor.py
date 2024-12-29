# Generated by Django 5.1.4 on 2024-12-27 19:19

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0019_actor_additional_info_date_of_birth_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='actor_additional_info',
            name='actor',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='additional_info', to=settings.AUTH_USER_MODEL),
        ),
    ]
