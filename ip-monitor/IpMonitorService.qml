pragma Singleton
import QtQuick

QtObject {
  id: service
  
  // Increment this to trigger refresh in all listening widgets
  property int refreshTrigger: 0
  
  // Cached IP data shared between widget and panel
  property var cachedIpData: null
  property string cachedFetchState: "idle" // idle, loading, success, error
  property int cachedLastFetchTime: 0
  
  function triggerRefresh() {
    refreshTrigger++;
  }
  
  function updateCache(data, state, timestamp) {
    cachedIpData = data;
    cachedFetchState = state;
    cachedLastFetchTime = timestamp;
  }
}

