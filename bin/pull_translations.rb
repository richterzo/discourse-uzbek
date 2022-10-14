#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/inline'

gemfile(true) do
  gem 'translations-manager', git: 'https://github.com/gschlager/translations-manager.git'
end

require 'translations_manager'
require "translations_manager/duplicate_remover"
require 'yaml'

YML_DIRS = ['../../config/locales'].map { |d| File.expand_path(d, __FILE__) }
YML_FILE_PREFIXES = ['client', 'server']
TRANSIFEX_LOCALE = 'de_DE'
DISCOURSE_LOCALE = 'de_formal'
LOCALES = ['de_DE']

class SourceDownloader
  include TranslationsManager::Common

  def download
    execute_tx_command('tx pull --source')
    modify_files
  end

  def modify_files
    puts '', 'Cleaning up YML files...'

    YML_DIRS.each do |dir|
      YML_FILE_PREFIXES.each do |prefix|
        path = File.join(dir, "#{prefix}.de.yml")
        next if !File.exist?(path)

        TranslationsManager::CharacterReplacer.replace_in_file!(path)
        TranslationsManager::LocaleFileCleaner.new(path).clean!
      end
    end
  end
end

def remove_duplicates
  SourceDownloader.new.download

  YML_DIRS.each do |dir|
    YML_FILE_PREFIXES.each do |prefix|
      source_filename = File.join(dir, "#{prefix}.de.yml")
      target_filename = File.join(dir, "#{prefix}.de_formal.yml")

      if File.exist?(source_filename)
        if File.exist?(target_filename)
          TranslationsManager::DuplicateRemover.new(source_filename, target_filename).clean!
        end

        File.delete(source_filename)
      end
    end
  end
end

TranslationsManager::TransifexUpdater
  .new(YML_DIRS, YML_FILE_PREFIXES, *LOCALES)
  .after_pull { remove_duplicates }
  .perform(
    update_tx_config: false,
    language_map: { TRANSIFEX_LOCALE => DISCOURSE_LOCALE }
  )
