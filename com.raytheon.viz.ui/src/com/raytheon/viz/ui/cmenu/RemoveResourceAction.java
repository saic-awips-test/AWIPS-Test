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

package com.raytheon.viz.ui.cmenu;

import com.raytheon.uf.viz.core.IDisplayPane;
import com.raytheon.uf.viz.core.rsc.AbstractVizResource;
import com.raytheon.uf.viz.core.rsc.ResourceList;
import com.raytheon.uf.viz.core.rsc.capabilities.BlendableCapability;
import com.raytheon.uf.viz.core.rsc.capabilities.BlendedCapability;

/**
 * Remove a resource from the map
 * 
 * <pre>
 * SOFTWARE HISTORY
 * Date         Ticket#     Engineer    Description
 * ------------ ----------  ----------- --------------------------
 * Nov 13, 2006            chammack    Initial Creation.
 * 
 * </pre>
 * 
 * @author chammack
 * @version 1
 */

public class RemoveResourceAction extends AbstractRightClickAction {

    /*
     * (non-Javadoc)
     * 
     * @see org.eclipse.jface.action.Action#run()
     */
    @Override
    public void run() {
        AbstractVizResource<?, ?> rsc = getSelectedRsc();
        ResourceList list = null;
        if (rsc.hasCapability(BlendedCapability.class)) {
            list = rsc.getCapability(BlendedCapability.class)
                    .getBlendableResource().getResource()
                    .getCapability(BlendableCapability.class).getResourceList();
            rsc.unload(list);
            if (list.size() == 0) {
                rsc.getCapability(BlendedCapability.class)
                        .getBlendableResource().getResource().unload();
            }
        } else {
            IDisplayPane activePane = rsc.getResourceContainer()
                    .getActiveDisplayPane();
            if (activePane != null) {
                rsc.unload(activePane.getDescriptor().getResourceList());
            } else {
                rsc.unload();
            }
        }

        getContainer().refresh();
    }

    /*
     * (non-Javadoc)
     * 
     * @see org.eclipse.jface.action.Action#getText()
     */
    @Override
    public String getText() {
        return "Unload";
    }

    /*
     * (non-Javadoc)
     * 
     * @see com.raytheon.viz.ui.cmenu.AbstractRightClickAction#isHidden()
     */
    @Override
    public boolean isHidden() {
        return !getSelectedRsc().okToUnload();
    }

}
