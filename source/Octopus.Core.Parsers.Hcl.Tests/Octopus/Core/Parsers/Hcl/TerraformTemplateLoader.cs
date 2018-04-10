﻿using System.IO;
using System.Reflection;

using Octopus.Core.Parsers.Hcl;

namespace Octopus.Tests.Octopus.Terraform.Templates
{
    public class TerraformTemplateLoader
    {
        protected string TerraformLoadTemplate(string fileName)
        {
            var templatesPath = Path.Combine(
                Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location),
                @"Octopus\Core\Parsers\Hcl\TemplateSamples");

            return HclParser.NormalizeLineEndings(File.ReadAllText(Path.Combine(templatesPath, fileName))).Trim();
        }
    }
}