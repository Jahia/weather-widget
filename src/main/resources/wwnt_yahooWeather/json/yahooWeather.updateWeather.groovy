import org.jahia.services.content.JCRCallback
import org.jahia.services.content.JCRSessionWrapper
import org.jahia.services.content.JCRTemplate
import org.jahia.api.Constants
import org.joda.time.DateTime
import org.yql4j.*

import javax.jcr.RepositoryException

def currentNodePath = currentResource.getNode().getPath()
def currentLocale = currentResource.locale

def callback = new JCRCallback() {
    @Override
    Object doInJCR(JCRSessionWrapper session) throws RepositoryException {
        def currentDefNode = session.getNode(currentNodePath);
        def currentDateTimeMinus = new DateTime().minusMinutes(30);
        def isMoreThan30Min = true
        if (currentDefNode.hasProperty("lastDateUpdate")) {
            def lastDateUpdate = new DateTime(currentDefNode.getProperty("lastDateUpdate").getDate())
            isMoreThan30Min = currentDateTimeMinus.isAfter(lastDateUpdate)
        }

        if (isMoreThan30Min) {
            def yqlClient = YqlClients.createDefault()
            def yqlQuery = YqlQueryBuilder.fromQueryString("select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\""
                    + currentDefNode.getProperty("city").string + ", " + currentDefNode.getProperty("country").string + "\") and u=\"" + currentDefNode.getProperty("units").string + "\"").build()
            yqlQuery.setFormat(ResultFormat.JSON)
            def yqlResult = yqlClient.query(yqlQuery)
            def stringResult = yqlResult.getContentAsString()

            currentDefNode.setProperty("lastData", stringResult)
            currentDefNode.setProperty("lastDateUpdate", new DateTime().toCalendar(currentLocale))
            session.save()
            return stringResult
        } else {
            return currentDefNode.getProperty("lastData").string
        }
    }
}
println(JCRTemplate.getInstance().doExecute(true, renderContext.user.username, Constants.EDIT_WORKSPACE, callback))
