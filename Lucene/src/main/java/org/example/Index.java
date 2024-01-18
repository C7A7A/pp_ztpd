package org.example;

import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;

import java.io.IOException;
import java.nio.file.Paths;

public class Index {
    public static String INDEX_DIRECTORY = "./index_dir";
    public static void main(String[] args) throws IOException {
        Directory directory = FSDirectory.open(Paths.get(INDEX_DIRECTORY));
        StandardAnalyzer analyzer = new StandardAnalyzer();
        IndexWriterConfig config = new IndexWriterConfig(analyzer);
        IndexWriter w = new IndexWriter(directory, config);

        w.addDocument(Main.buildDoc("Lucene in Action", "9781473671911"));
        w.addDocument(Main.buildDoc("Lucene for Dummies", "9780735219090"));
        w.addDocument(Main.buildDoc("Managing Gigabytes", "9781982131739"));
        w.addDocument(Main.buildDoc("The Art of Computer Science", "9781250301695"));
        w.addDocument(Main.buildDoc("Dummy and yummy title", "9780525656161"));
        w.close();
    }
}
