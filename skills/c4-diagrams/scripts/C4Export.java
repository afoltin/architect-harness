import com.structurizr.Workspace;
import com.structurizr.dsl.StructurizrDslParser;
import com.structurizr.export.Diagram;
import com.structurizr.export.plantuml.StructurizrPlantUMLExporter;
import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;

/**
 * Fallback exporter for machines without the Homebrew "structurizr" command
 * (for example a cloud sandbox). It does the same as:
 *   structurizr export -workspace <dsl> -format plantuml/structurizr -output <dir>
 * Classpath needs structurizr-dsl and structurizr-export (Maven Central).
 */
public class C4Export {
    public static void main(String[] args) throws Exception {
        StructurizrDslParser parser = new StructurizrDslParser();
        parser.parse(new File(args[0]));
        Workspace ws = parser.getWorkspace();
        Path out = Paths.get(args[1]);
        Files.createDirectories(out);
        for (Diagram d : new StructurizrPlantUMLExporter().export(ws)) {
            Files.writeString(out.resolve("structurizr-" + d.getKey() + ".puml"), d.getDefinition(), StandardCharsets.UTF_8);
        }
    }
}
