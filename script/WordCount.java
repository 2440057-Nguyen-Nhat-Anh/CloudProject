import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaSparkContext;
import scala.Tuple2;

public class WordCount {

    public static void main(String[] args) {
        SparkConf conf = new SparkConf()
                .setAppName("WordCount");

        JavaSparkContext sc = new JavaSparkContext(conf);

        long t1 = System.currentTimeMillis();

        JavaRDD<String> lines = sc.textFile(args[0]);

        JavaRDD<String> words = lines.flatMap(line -> 
            java.util.Arrays.asList(line.split(" ")).iterator()
        );

        JavaPairRDD<String, Integer> ones = words.mapToPair(
            w -> new Tuple2<>(w, 1)
        );

        JavaPairRDD<String, Integer> counts = ones.reduceByKey(
            (a, b) -> a + b
        );

        counts.saveAsTextFile(args[1]);

        long t2 = System.currentTimeMillis();
        System.out.println("time in ms = " + (t2 - t1));

        sc.close();
    }
}
