# Generated by Django 5.1.4 on 2025-02-13 20:23

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0028_rename_end_date_booking_dates_date_and_more'),
    ]

    operations = [
        migrations.CreateModel(
            name='camera_location',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('video', models.FileField(upload_to='camera_location_input/')),
                ('generated_video', models.FileField(upload_to='camera_location_output/')),
                ('director', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
