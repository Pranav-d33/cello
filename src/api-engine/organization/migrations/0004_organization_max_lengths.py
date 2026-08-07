from django.db import migrations, models

import common.validators


class Migration(migrations.Migration):

    dependencies = [
        ("organization", "0003_alter_organization_agent_url"),
    ]

    operations = [
        migrations.AlterField(
            model_name="organization",
            name="name",
            field=models.CharField(
                help_text="Organization Name",
                max_length=256,
                unique=True,
                validators=[common.validators.validate_host],
            ),
        ),
    ]
