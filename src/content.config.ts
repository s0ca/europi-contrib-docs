import { defineCollection } from 'astro:content';
import { docsLoader, i18nLoader } from '@astrojs/starlight/loaders';
import { docsSchema, i18nSchema } from '@astrojs/starlight/schema';

export const collections = {
  docs: defineCollection({ loader: docsLoader(), schema: docsSchema() }),
  // optionnel, mais safe à avoir si tu ajoutes de l’i18n plus tard
  i18n: defineCollection({ loader: i18nLoader(), schema: i18nSchema() }),
};
