/**
 * This software was developed and / or modified by Raytheon Company,
 * pursuant to Contract DG133W-05-CQ-1067 with the US Government.
 * 
 * U.S. EXPORT CONTROLLED TECHNICAL DATA
 * This software product contains export-restricted data whose
 * export/transfer/disclosure is restricted by U.S. law. Dissemination
 * to non-U.S. persons whether in the United States or abroad requires
 * an export license or other authorization.
 * 
 * Contractor Name:        Raytheon Company
 * Contractor Address:     6825 Pine Street, Suite 340
 *                         Mail Stop B8
 *                         Omaha, NE 68106
 *                         402.291.0100
 * 
 * See the AWIPS II Master Rights File ("Master Rights File.pdf") for
 * further licensing information.
 **/
package com.raytheon.uf.viz.collaboration.display.storage;

import com.raytheon.uf.viz.collaboration.comm.identity.CollaborationException;
import com.raytheon.uf.viz.remote.graphics.events.AbstractDispatchingObjectEvent;

/**
 * Interface for persisting remote object events
 * 
 * <pre>
 * 
 * SOFTWARE HISTORY
 * 
 * Date         Ticket#    Engineer    Description
 * ------------ ---------- ----------- --------------------------
 * Apr 20, 2012            mschenke     Initial creation
 * Apr 08, 2014 2968       njensen      Added byte[] data arg to persistEvent
 * 
 * </pre>
 * 
 * @author mschenke
 * @version 1.0
 */

public interface IObjectEventPersistance {

    /**
     * Persists an event to the remote service
     * 
     * @param event
     *            the event to persist
     * @param data
     *            the event transformed to bytes
     * @return an IPersistedEvent that references the remotely persisted event
     * @throws CollaborationException
     */
    public IPersistedEvent persistEvent(AbstractDispatchingObjectEvent event,
            byte[] data) throws CollaborationException;

    public void dispose() throws CollaborationException;
}
