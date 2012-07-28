package com.stitchemapp.daos;

import java.io.Serializable;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.persistence.Entity;
import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import org.apache.log4j.Logger;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.queryParser.MultiFieldQueryParser;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.util.Version;
import org.hibernate.Session;
import org.hibernate.search.annotations.Indexed;
import org.hibernate.search.jpa.FullTextEntityManager;
import org.hibernate.search.jpa.FullTextQuery;
import org.hibernate.search.jpa.Search;
import org.springframework.dao.DataAccessException;

import com.stitchemapp.api.IDao;
import com.stitchemapp.api.IEntity;
import com.stitchemapp.constants.Constants;

public class GenericJpaDao implements IDao {

	protected EntityManager entityManager;
	public static final Logger LOGGER = Logger.getLogger(GenericJpaDao.class);
	
	/* Getters and Setters */
	
	public EntityManager getEntityManager() {
		return entityManager;
	}

	@PersistenceContext
	public void setEntityManager(EntityManager entityManager) {
		this.entityManager = entityManager;
	}

	
	
	
	/* Basic CRUD methods --- Save Find Update Delete */
	
	public <E extends IEntity> void save(E inEntity) throws DataAccessException {
		if(inEntity != null)
			entityManager.persist(inEntity);
		
	}

	public <E extends IEntity,K extends Serializable> E find(Class<E> inEntityClass, K inPkey)	throws DataAccessException {
		return entityManager.find(inEntityClass, inPkey);
	}

	public <E extends IEntity> E update(E inEntity) throws DataAccessException {
		if(inEntity != null)
			return entityManager.merge(inEntity);
		
		return null;
	}

	public <E extends IEntity> void delete(E inEntity) throws DataAccessException {
		if(inEntity != null)
			entityManager.remove(inEntity);
	}
	
	
	
	/* Other Methods */

	public <E extends IEntity> List<E> findAllEntities(Class<E> inEntityClass) {
		return findAllEntities(inEntityClass, null);
	}

	public <E extends IEntity> List<E> findAllEntities(Class<E> inEntityClass, String orderby) {
		
		String entityClsName = inEntityClass.getSimpleName();
		
		Entity entity = inEntityClass.getAnnotation(Entity.class);
		if (entity != null) {
			String eName = entity.name();
			if (eName != null && eName.length() > 0) {
				entityClsName = eName;
			}
		}

		String sQuery = "SELECT instance FROM " + entityClsName + " instance";
		if (orderby == null) {
			sQuery = sQuery + " order by instance.createdOn DESC";
		} else {
			sQuery = sQuery + " order by instance." + orderby;
		}
			
		Query query = entityManager.createQuery(sQuery);
		return (List<E>) query.getResultList();
	}
	
	public <E extends IEntity> List<E> findAllEntities(Class<E> inEntityClass, String orderby,  Integer pageNumber, Integer pageSize) {
		
		String entityClsName = inEntityClass.getSimpleName();
		
		Entity entity = inEntityClass.getAnnotation(Entity.class);
		if (entity != null) {
			String eName = entity.name();
			if (eName != null && eName.length() > 0) {
				entityClsName = eName;
			}
		}

		String sQuery = "SELECT instance FROM " + entityClsName + " instance";
		if (orderby == null) {
			sQuery = sQuery + " order by instance.createdOn ASC";
		} else {
			sQuery = sQuery + " order by instance." + orderby;
		}

		Query query = entityManager.createQuery(sQuery);
		
		query = query.setFirstResult(pageSize * (pageNumber - 1));
		query.setMaxResults(pageSize);
		
		return (List<E>) query.getResultList();
		
	}

	
	public <E extends IEntity> List<Object> getResultsByFieldName(Class<E> inEntityClass, String fieldName) throws DataAccessException {
		
		String entityClsName = inEntityClass.getSimpleName();
		
		Entity entity = inEntityClass.getAnnotation(Entity.class);
		if (entity != null) {
			String eName = entity.name();
			if (eName != null && eName.length() > 0) {
				entityClsName = eName;
			}
		}
		
		String sQuery = "";
		if(fieldName != null) {
			sQuery = "SELECT instance." + fieldName + " FROM " + entityClsName + " instance";
		}
		
		Query query = entityManager.createQuery(sQuery);
		
		return (List) query.getResultList();
	}
	
	
	
	public Object getResult(String queryName, Hashtable<String, Object> criteria) throws DataAccessException {
		
		Query qry = entityManager.createNamedQuery(queryName);
        Enumeration<String> keys = criteria.keys();
        while (keys.hasMoreElements()) {
            String key = keys.nextElement();
            qry.setParameter(key, criteria.get(key));
        }
        Object result;
        try {
            result = qry.getSingleResult();
        } catch (NoResultException nre) {
            return null;
        }
        return result;
	}

	public Object getResult(StringBuffer query,	Hashtable<String, Object> criteria) throws DataAccessException {
		
		Query qry = entityManager.createQuery(query.toString());
		Enumeration<String> keys = criteria.keys();
		while (keys.hasMoreElements()) {
		    String key = keys.nextElement();
		    qry.setParameter(key, criteria.get(key));
		}
		Object result;
		try {
		    result = qry.getSingleResult();
		} catch (NoResultException nre) {
		    return null;
		}
		return result;
	}

	public List getResults(String queryName, Hashtable<String, Object> criteria) throws DataAccessException {
		
		Query qry = entityManager.createNamedQuery(queryName);
		Enumeration<String> keys = criteria.keys();
		while (keys.hasMoreElements()) {
		    String key = keys.nextElement();
		    qry.setParameter(key, criteria.get(key));
		}
		List result;
		try {
		    result = qry.getResultList();
		} catch (NoResultException nre) {
		    return null;
		}
		return result;
	}

	public <E extends IEntity, obj extends Object> E getEntity(Class<E> inElementClass, String queryName, Hashtable<String, obj> criteria)	throws DataAccessException {
		Query qry = entityManager.createNamedQuery(queryName);
		Enumeration<String> keys = criteria.keys();
		while (keys.hasMoreElements()) {
			String key = keys.nextElement();
			qry.setParameter(key, criteria.get(key));
		}
		Object result;
		try {
			result = qry.getSingleResult();
		} catch (NoResultException nre) {
			return null;
		}
		return (E) result;
	}

	public <E extends IEntity, obj extends Object> List<E> getEntities(Class<E> inElementClass, String queryName, Hashtable<String, obj> criteria) throws DataAccessException {
		Query qry = entityManager.createNamedQuery(queryName);
		Enumeration<String> keys = criteria.keys();
		while (keys.hasMoreElements()) {
			String key = keys.nextElement();
			qry.setParameter(key, criteria.get(key));
		}
		Object result;
		try {
			result = qry.getResultList();
		} catch (NoResultException nre) {
			return null;
		}
		return (List<E>) result;
	}
	
	
	public <E extends IEntity, obj extends Object> List<E> getEntities(Class<E> inElementClass, String queryName, Hashtable<String, obj> criteria, Integer pageNumber, Integer pageSize) throws DataAccessException {
		Query qry = entityManager.createNamedQuery(queryName);
		Enumeration<String> keys = criteria.keys();
		while (keys.hasMoreElements()) {
			String key = keys.nextElement();
			qry.setParameter(key, criteria.get(key));
		}
		Object result;
		try {
			qry = qry.setFirstResult(pageSize * (pageNumber - 1));
			qry.setMaxResults(pageSize);
			result = qry.getResultList();
		} catch (NoResultException nre) {
			return null;
		}
		return (List<E>) result;
	}


	public <E extends IEntity, obj extends Object> List<E> getEntities(Class<E> inElementClass, StringBuffer query, Hashtable<String, obj> criteria) {
		Query qry = entityManager.createQuery(query.toString());
		Enumeration<String> keys = criteria.keys();
		while (keys.hasMoreElements()) {
			String key = keys.nextElement();
			qry.setParameter(key, criteria.get(key));
		}
		Object result;
		try {
			result = qry.getResultList();
		} catch (NoResultException nre) {
			return null;
		}
		return (List<E>) result;
	}

	public <E extends IEntity, obj extends Object> List<E> getEntities(Class<E> inElementClass, StringBuffer query, Hashtable<String, obj> criteria, Integer pageNumber, Integer pageSize) {
		Query qry = entityManager.createQuery(query.toString());
		Enumeration<String> keys = criteria.keys();
		while (keys.hasMoreElements()) {
			String key = keys.nextElement();
			qry.setParameter(key, criteria.get(key));
		}
		Object result;
		try {
			if(pageNumber != -1 && pageSize != -1) {
				qry = qry.setFirstResult(pageSize * (pageNumber - 1));
				qry.setMaxResults(pageSize);
			}
			result = qry.getResultList();
		} catch (NoResultException nre) {
			return null;
		}
		return (List<E>) result;
	}

	public <E extends IEntity> List<E> getEntities(Class<E> inElementClass, StringBuffer query) throws DataAccessException {
		Query qry = entityManager.createQuery(query.toString());
		Object result;
		try {
			result = qry.getResultList();
		} catch (NoResultException nre) {
			return null;
		}
		return (List<E>) result;
	}

	
	
    /* Counts */
	
	public <E extends IEntity> Integer fetchEntitiesCount( Class<E> inEntityClass ) {
		String entityClsName = inEntityClass.getSimpleName();
		String sQuery = "SELECT count(instance) from " + entityClsName + " instance";
		
		Query query = entityManager.createQuery(sQuery);
		Long count = (Long) query.getSingleResult();
		return Integer.valueOf(count.toString());
	}

	public <E extends IEntity> Integer fetchEntitiesCount( Class<E> inEntityClass, Hashtable<String, Object> criteria ) {
		
		String entityClsName = inEntityClass.getSimpleName();
		
		StringBuffer sQuery = new StringBuffer();
		sQuery.append("SELECT count(instance) from ").append(entityClsName.toString()).append(" instance WHERE ");
		
		Iterator it = criteria.entrySet().iterator();
	    while (it.hasNext()) {
	        Map.Entry pairs = (Map.Entry)it.next();
	        sQuery.append("instance.").append(pairs.getKey()).append("=:").append(pairs.getKey());
//	        it.remove();
	        
	        if(it.hasNext())
	        	sQuery.append(" AND ");
	    }
		
		Query query = entityManager.createQuery(sQuery.toString());
		
		Enumeration<String> keys = criteria.keys();
	    while (keys.hasMoreElements()) {
			String key = keys.nextElement();
			query.setParameter(key, criteria.get(key));
		}
		
		Long count = (Long) query.getSingleResult();
		return Integer.valueOf(count.toString());
		
	}

	public <E extends IEntity> Integer fetchSearchResultsCount( Class<E> inEntityClass, String entityField, String searchString ) {
		
		searchString = "%" + searchString + "%";
		
		String entityClsName = inEntityClass.getSimpleName();
		String sQuery = "SELECT count(instance) from " + entityClsName + " instance WHERE instance." + entityField + " like :searchString";
		
		Query query = entityManager.createQuery(sQuery);
		query.setParameter("searchString", searchString);
				
		Long count = (Long) query.getSingleResult();
		return Integer.valueOf(count.toString());
	}

	
	
	
	/* Search Related */
	
	public <E extends IEntity> List<E> searchEntityByField(Class<E> inEntityClass, String entityField, String searchString) {
		
		searchString = "%" + searchString + "%";
		
		String entityClsName = inEntityClass.getSimpleName();
		String sQuery = "SELECT instance from " + entityClsName + " instance WHERE instance." + entityField + " like :searchString" ;
		
		Query query = entityManager.createQuery(sQuery);
		query.setParameter("searchString", searchString);
		
		return (List<E>)query.getResultList();
		
	}

	public <E extends IEntity> List<E> searchEntityByField(Class<E> inEntityClass, String entityField, String searchString, 
			Integer pageNum, Integer pageSize) {
		
		searchString = "%" + searchString + "%";
		
		String entityClsName = inEntityClass.getSimpleName();
		String sQuery = "SELECT instance from " + entityClsName + " instance WHERE instance." + entityField + " like :searchString" ;
		
		StringBuffer queryStrBuffer = new StringBuffer(sQuery);
		
		Hashtable<String, Object> criteria = new Hashtable<String, Object>();
		criteria.put("searchString", searchString);
		
		return this.getEntities(inEntityClass, queryStrBuffer, criteria, pageNum, pageSize);
		
	}
	
	public <E extends IEntity> List<E> searchEntityByField(Class<E> inEntityClass, List<String> projections, String entityField, String searchString) {
		
		searchString = "%" + searchString + "%";
		
		String projectionStr = "";
		for (int i = 0; i < projections.size(); i++) {
			String projection = projections.get(i);
			if( projection != null && projection != "") {
				projectionStr = projectionStr + "instance." + projection;
			}
			
			if (i+1 != projections.size()) {
				projectionStr = projectionStr + ",";
			}
			
		}
		
		String entityClsName = inEntityClass.getSimpleName();
		String sQuery = "SELECT " + projectionStr + " from " + entityClsName + " instance WHERE instance." + entityField + " like :searchString" ;
		
		Query query = entityManager.createQuery(sQuery);
		query.setParameter("searchString", searchString);
		
		return query.getResultList();
	}

	public <E extends IEntity> List<E> searchEntityByField(Class<E> inEntityClass, List<String> projections, String entityField, String searchString,
			Integer pageNum, Integer pageSize) {
		
		searchString = "%" + searchString + "%";
		
		String projectionStr = "";
		for (int i = 0; i < projections.size(); i++) {
			String projection = projections.get(i);
			if( projection != null && projection != "") {
				projectionStr = projectionStr + "instance." + projection;
			}
			
			if (i+1 != projections.size()){
				projectionStr = projectionStr + ",";
			}
		}
		
		String entityClsName = inEntityClass.getSimpleName();
		String sQuery = "SELECT " + projectionStr + " from " + entityClsName + " instance WHERE instance." + entityField + " like :searchString" ;
		
		
		StringBuffer strBuffer = new StringBuffer(sQuery);
		
		Hashtable<String, Object> criteria = new Hashtable<String, Object>();
		criteria.put("searchString", searchString);
		
		return getEntities(inEntityClass, strBuffer, criteria, pageNum, pageSize);
	}

	
	
	// LUCENE Related
	
	public List fullTextSearch(String searchText, String[] projections,
			String[] entityFields, Class[] classes, Map<String, Float> boostMap) {
		
		FullTextEntityManager fullTextEntityManager = Search.getFullTextEntityManager(entityManager);
		QueryParser parser;
		
		if(boostMap != null){
			parser = new MultiFieldQueryParser(Version.LUCENE_31, entityFields, new StandardAnalyzer(Version.LUCENE_31), boostMap);
		} else {
			parser = new MultiFieldQueryParser(Version.LUCENE_31, entityFields, new StandardAnalyzer(Version.LUCENE_31));
		}
		
		org.apache.lucene.search.Query luceneQuery;
		
		try {
			luceneQuery = parser.parse(searchText);
		} catch (ParseException e) {
			throw new RuntimeException("Unable to parse query: " + searchText, e);
		}
		
		FullTextQuery query = null;
		
		if(classes.length == 1){
			query = fullTextEntityManager.createFullTextQuery(luceneQuery, classes[0]);
		} else if(classes.length==2){
			query = fullTextEntityManager.createFullTextQuery(luceneQuery, classes[0], classes[1]);
		}
		
		if(query != null){
			query.setProjection(projections);
			return query.getResultList();
		}
		
		return null;
		
	}

	public <E extends IEntity> void doIndex(Class<E> entity) {
		
		FullTextEntityManager ftEntityManager = Search.getFullTextEntityManager(entityManager);
		
		String entityName = entity.getCanonicalName();
		if (entity.getAnnotation(Indexed.class) != null) {
			LOGGER.info("Class " + entityName + " is indexed by hibernate search");

			int currentResult = 0;
            Session session = (Session) entityManager.getDelegate();
			Query tQuery = entityManager.createQuery("select c from " + entityName + " as c order by pkey asc");
			tQuery.setFirstResult(currentResult);
			tQuery.setMaxResults(Constants.MAX_RESULT_INDEX_SIZE);

			List entities;

			do {
				entities = tQuery.getResultList();
				for (Object object : entities) {
					ftEntityManager.index(object);
					LOGGER.info("Indexed " + entityName + " with pkey " + ((IEntity) object).getPkey());

				}
                if (currentResult % Constants.MAX_RESULT_INDEX_SIZE == 0) {
                    session.evict(entities);
                    ftEntityManager.flushToIndexes(); //apply changes to indexes
                    ftEntityManager.clear(); //clear since the queue is processed
                    session.flush();
                    session.clear();
                }

				currentResult += Constants.MAX_RESULT_INDEX_SIZE;
				tQuery.setFirstResult(currentResult);
				
			} while (entities.size() == Constants.MAX_RESULT_INDEX_SIZE);
			
			LOGGER.info("Finished indexing for " + entityName);

		}
	}

	public void executeIndexThroJob(Class entityClass, List entities) {
		
		FullTextEntityManager ftEntityManager = Search.getFullTextEntityManager(entityManager);
		
		String entityName = entityClass.getCanonicalName();
		Session session = (Session) entityManager.getDelegate();
		if (entityClass.getAnnotation(Indexed.class) != null) {
			for (Object object : entities) {
				ftEntityManager.index(object);
				
				LOGGER.info("Indexed " + entityName + " with pkey " + ((IEntity) object).getPkey());
			}
			
			session.evict(entities);
	        ftEntityManager.flushToIndexes(); //apply changes to indexes
	        ftEntityManager.clear(); //clear since the queue is processed
	        session.flush();
	        session.clear();
	        
		} else {
			
			LOGGER.info(entityName + " is not an indexable entity");
		}
	}

	public void doSingleObjectIndex(IEntity entity) {
		
		if (entity.getClass().getAnnotation(Indexed.class) != null) {
			FullTextEntityManager ftEntityManager = Search.getFullTextEntityManager(entityManager);
			ftEntityManager.index(entity);
			
			LOGGER.info("Indexed " + entity.getClass().getCanonicalName() + " with pkey " + ((IEntity) entity).getPkey());
            
			ftEntityManager.flushToIndexes(); //apply changes to indexes
		
		} else {
			
			LOGGER.info(entity.getClass().getCanonicalName() + " is not an indexable entity");
		}
	}
	
	
}
