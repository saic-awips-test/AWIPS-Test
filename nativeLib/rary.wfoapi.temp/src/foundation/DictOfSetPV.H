// ---------------------------------------------------------------------------
// This software is in the public domain, furnished "as is", without technical
// support, and with no warranty, express or implied, as to its usefulness for
// any purpose.
//
// DictOfSetPV.H
// General-purpose dictionary of set class template
//
// Author: Brian Woods
// ---------------------------------------------------------------------------
#ifndef _DictOfSetPV_H
#define _DictOfSetPV_H

#ifdef IDENT_TEMPLATE_H
static const char* const DictOfSetPV_H_Id =
"$Id: .DictOfSetPV.H__temp27950,v 1.2 2003/05/06 23:11:40 fluke Exp $";
#endif

#include "commonDefs.h"
#include "Set.H"
#include "DictOfSet.H"

template <class K, class V>
class DictOfSetPV
    {
    public:
        // using default c'tor's and d'tor

        //operations upon the sets
        bool map(const K &key) const { return impl.map( (void* &) key ); }
        bool map(const K &key, Set<V> &set) const
            { return impl.map( (void* &) key, set ); }
        
        void add(const K &key, const Set<V> &set)
            { impl.add( (void* &) key, set ); }
        void remove(const K &key)
            { impl.remove( (void* &) key ); }
        int size(void) const             { return impl.size(); }
        void orderByK(void) const        { impl.orderByK(); }
        const K &key(int i) const        { return (const K&) impl.key( i ); }
        const Set<V> &value(int i) const { return impl.value( i ); } 
       

        // Operations on the set's elements
        bool map(const K &key, const V &val) const
            { return impl.map( (void * &) key, val ); }
        
        void remove(const K &key, const V &val)
            { impl.remove( (void* &) key, val ); }
        void add(const K &key, const V &val)
            { impl.add( (void* &) key, val ); }
        int size(const K& key)
            { return impl.size( (void* &) key ); }
        void orderByK(const K &key) const
            { impl.orderByK( (void* &) key ); }
        const V &value(const K &key, int i) const
            { return impl.value( (void* &) key, i ); }

        // Set operations
        void setUnion(const K &key, const Set<V> &rhs)
            { impl.setUnion( (void* &) key, rhs ); }
        
        void setIntersection(const K &key, const Set<V> &rhs)
            { impl.setIntersection( (void* &) key, rhs ); }
        
        void setMinus(const K &key, const Set<V> &rhs)
            { impl.setMinus( (void* &) key, rhs ); }
        
        bool isRhsSubset(const K &key, const Set<V> &rhs)
            { return impl.isRhsSubset( (void* &) key, rhs ); }
        
        bool isRhsProperSubset(const K &key, const Set<V> &rhs)
            { return impl.isRhsProperSubset( (void* &) key, rhs ); }
        
        bool mutuallyInclusive(const K &key, const Set<V> &rhs)
            { return impl.mutuallyInclusive( (void* &) key, rhs ); }
        
        bool mutuallyExclusive(const K &key, const Set<V> &rhs)
            { return impl.mutuallyExclusive( (void* &) key, rhs ); }

        // Comparrison operators on the dictionaries
        bool operator==(const DictOfSetPV<K,V> &rhs) const
            { return impl == rhs.impl; }
        bool operator!=(const DictOfSetPV<K,V> &rhs) const
            { return !operator==( rhs ); }

        float testsPerSearch(void) const // key==key's per map/add/remove
            { return impl.testsPerSearch(); }

    private:
        DictOfSet<void *, V> impl;
    };


#endif
