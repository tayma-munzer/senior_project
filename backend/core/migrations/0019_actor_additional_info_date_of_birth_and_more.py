# Generated by Django 5.1.4 on 2024-12-27 10:00

import django.utils.timezone
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0018_alter_location_videos_video'),
    ]

    operations = [
        migrations.AddField(
            model_name='actor_additional_info',
            name='date_of_birth',
            field=models.DateField(auto_now_add=True, default=django.utils.timezone.now),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='actor_additional_info',
            name='personal_image',
            field=models.ImageField(default='personal_image/default.jpg', upload_to='personal_image/'),
        ),
        migrations.AlterField(
            model_name='artwork',
            name='poster',
            field=models.ImageField(upload_to='images/'),
        ),
        migrations.AlterField(
            model_name='artwork_gallery',
            name='poster',
            field=models.ImageField(upload_to='images/'),
        ),
        migrations.AlterField(
            model_name='location_photos',
            name='photo',
            field=models.ImageField(upload_to='images/'),
        ),
        migrations.AlterField(
            model_name='location_videos',
            name='video',
            field=models.FileField(upload_to='videos/'),
        ),
        migrations.AlterField(
            model_name='official_document',
            name='document',
            field=models.FileField(upload_to='documents/'),
        ),
    ]
